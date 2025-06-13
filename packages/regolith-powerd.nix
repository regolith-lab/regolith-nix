{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, glib
,
}:

rustPlatform.buildRustPackage rec {
  pname = "regolith-powerd";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "regolith-powerd";
    rev = "v${version}";
    hash = "sha256-Hu6EhNBClHsh0mrOAfPw848q0czoivoYnpiE9/+drK4=";
  };

  cargoHash = "sha256-HHnilpOW1bnhxFqy5l5+FPO8Qp5zSAE/k14unK/gEig=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  # postInstall = ''
  #   mkdir -p $out/lib/systemd/user/
  #   install -Dm644 data/regolith-init-powerd.service $out/lib/systemd/user/
  #   ls
  #   ls $src
  # '';

  meta = {
    description = "Daemon to sync gsd power settings with Regolith on Wayland. Provides idle state functionality and sets power button action";
    homepage = "https://github.com/regolith-linux/regolith-powerd";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "regolith-powerd";
  };
}
