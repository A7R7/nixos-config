{ lib, stdenv, vscode, gnused, writeText, gawk, coreutils }:

let
  customCssContent = builtins.readFile ./custom.css;
  customJsContent = builtins.readFile ./cursor.js;

  injections = ''
    <!-- !! VSCODE-CUSTOM-CSS-JS-START !! -->
    <style>
    ${customCssContent}
    </style>
    <script>
    ${customJsContent}
    </script>
    <!-- !! VSCODE-CUSTOM-CSS-JS-END !! -->
  '';

  injectionsFile = writeText "vscode-injections.html" injections;

in stdenv.mkDerivation rec {
  pname = "vscode-custom";
  version = vscode.version;
  src = vscode;

  nativeBuildInputs = [ gnused gawk coreutils ];
  dontStrip = true;
  
  passthru = vscode.passthru;
  unpackPhase = ":"; 
  patchPhase = ":";
  configurePhase = ":";
  buildPhase = ":";
  installPhase = ''
    runHook preInstall

    cp -Rp "$src/." "$out/"
    chmod -R u+w "$out"

    # Paths are relative to $out (the output directory of the derivation)
    base_path="lib/vscode/resources/app/out/vs/code/electron-sandbox"
    workbench_html_path_pattern="$base_path/workbench/workbench.html"
    workbench_apc_html_path_pattern="$base_path/workbench-apc-extension.html"
    workbench_esm_html_path_pattern="$base_path/workbench.esm.html"

    TARGET_HTML_FILE=""
    # Note: $out is implicitly the current directory or prefix for these paths in installPhase
    if [ -f "$out/$workbench_html_path_pattern" ]; then
      TARGET_HTML_FILE="$out/$workbench_html_path_pattern"
    elif [ -f "$out/$workbench_apc_html_path_pattern" ]; then
      TARGET_HTML_FILE="$out/$workbench_apc_html_path_pattern"
    elif [ -f "$out/$workbench_esm_html_path_pattern" ]; then
      TARGET_HTML_FILE="$out/$workbench_esm_html_path_pattern"
    else
      echo "ERROR: Could not find workbench.html at expected paths in $out!"
      exit 1
    fi
    echo "Found workbench HTML for patching at: $TARGET_HTML_FILE"

    # Ensure the target file is writable
    chmod u+w "$TARGET_HTML_FILE"

    # Remove CSP meta tag
    sed -Ezi 's/<meta[[:space:]]+http-equiv="Content-Security-Policy".*?\/>//gI' "$TARGET_HTML_FILE"

    # Inject custom content
    awk '
      /<\/html>/ { system("cat ${injectionsFile}") }
      { print }
    ' "$TARGET_HTML_FILE" > "$TARGET_HTML_FILE".tmp && \
    mv "$TARGET_HTML_FILE".tmp "$TARGET_HTML_FILE"

    # Replace original path
    sed -i "s|$src|$out|g" "$out/bin/code"
    sed -i "s|$src|$out|g" "$out/bin/.code-wrapped"

    runHook postInstall
  '';
  
  fixupPhase = ":";
  
  meta = vscode.meta // {
    description = vscode.meta.description + " (with custom UI: CSS/JS)";
  };
}
