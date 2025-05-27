{ lib, stdenv, vscode, gnused, makeWrapper, writeText 
# , customCssFiles ? [./custom.css] # List of paths to your CSS files
# , customJsFiles ? [./custom.js]  # List of paths to your JS files
}:

let


in stdenv.mkDerivation rec {
  pname = "vscode-custom";
  version = "${vscode.version}-custom";

  nativeBuildInputs = [ gnused makeWrapper ];

  buildInputs = [ vscode ];

  passthru = vscode.passthru or { };
  dontBuild = true;
  dontUnpack = true;

  installPhase = /* bash */ ''
      runHook preInstall

      mkdir -p $out
      cp -rT ${vscode} $out
      chmod -R u+w $out

      # base_path = "$out/lib/vscode/resources/app/out/vs/code/electron-sandbox/"
      workbench_html_path_pattern="$out/lib/vscode/resources/app/out/vs/code/electron-sandbox/workbench/workbench.html"
      workbench_apc_html_path_pattern="$out/lib/vscode/resources/app/out/vs/code/electron-sandbox/workbench-apc-extension.html"
      workbench_esm_html_path_pattern="$out/lib/vscode/resources/app/out/vs/code/electron-sandbox/workbench.esm.html"

      TARGET_HTML_FILE=""
      if [ -f "$workbench_html_path_pattern" ]; then
        TARGET_HTML_FILE="$workbench_html_path_pattern"
      elif [ -f "$workbench_apc_html_path_pattern" ]; then
        TARGET_HTML_FILE="$workbench_apc_html_path_pattern"
      elif [ -f "$workbench_esm_html_path_pattern" ]; then
        TARGET_HTML_FILE="$workbench_esm_html_path_pattern"
      else
        echo "ERROR: Could not find workbench.html at expected paths in $out!"
        exit 1
      fi
      echo "Found workbench HTML for patching at: $TARGET_HTML_FILE"

      # patch
      # 3a. remove CSP
      # sed -i '/<meta[^>]*http-equiv="Content-Security-Policy"[^>]*>/Id' "$TARGET_HTML_FILE"      
      sed -Ezi 's/<meta[[:space:]]+http-equiv="Content-Security-Policy".*?\/>//gI' "$TARGET_HTML_FILE"
      echo "Removed CSP meta tag (if found)."

      # insert html
      echo '<!-- !! VSCODE-CUSTOM-CSS-JS-START !! -->' >> injections.html
      echo '<style>' >> injections.html
      cat ${./custom.css} >> injections.html
      echo '</style>' >> injections.html
      echo '<script>' >> injections.html
      cat ${./custom-debug.js} >> injections.html
      echo '</script>' >> injections.html
      echo '<!-- !! VSCODE-CUSTOM-CSS-JS-END !! -->' >> injections.html 
      
      awk '
        /<\/html>/ { system("cat injections.html") }
        { print }
      ' "$TARGET_HTML_FILE" > "$TARGET_HTML_FILE".tmp && \
      mv "$TARGET_HTML_FILE".tmp "$TARGET_HTML_FILE"

      echo "Injected custom JS."

      echo "VSCode Custom package created in $out"
      runHook postInstall
  '';

  meta = vscode.meta // {
    description =
      "VSCode with custom CSS/JS injected (${vscode.meta.description or ""})";
  };
}
