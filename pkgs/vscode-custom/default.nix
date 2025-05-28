{ lib, vscode, gnused, writeText}: # Removed stdenv and makeWrapper as vscode likely brings them

let
  customCssContent = builtins.readFile ./custom.css;
  customJsContent = builtins.readFile ./custom.js; 

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
  
  # injections = ''
  #   <!-- !! VSCODE-CUSTOM-CSS-JS-START !! -->
  #   <script src="/home/${userName}/.config/Code/User/custom.js" type="module"></script>
  #   <!-- !! VSCODE-CUSTOM-CSS-JS-END !! -->
  # '';

  injectionsFile = writeText "vscode-injections.html" injections;

in
vscode.overrideAttrs (oldAttrs: rec {
  pname = "${oldAttrs.pname}-custom";
  version = "${oldAttrs.version}-custom";
  
  postInstall = (oldAttrs.postInstall or "") + ''
    echo "--- Running Custom VSCode Post-Install Hook ---"

    # Paths are relative to $out (the output directory of the derivation)
    base_path="lib/vscode/resources/app/out/vs/code/electron-sandbox/"
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

    # 1. Remove CSP meta tag
    sed -Ezi 's/<meta[[:space:]]+http-equiv="Content-Security-Policy".*?\/>//gI' "$TARGET_HTML_FILE"

    # 2. Inject custom content
    awk '
      /<\/html>/ { system("cat ${injectionsFile}") }
      { print }
    ' "$TARGET_HTML_FILE" > "$TARGET_HTML_FILE".tmp && \
    mv "$TARGET_HTML_FILE".tmp "$TARGET_HTML_FILE"
    
    echo "--- Custom VSCode Post-Install Hook Finished ---"
  '';
})