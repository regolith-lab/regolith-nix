{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, glib
,
}:

rustPlatform.buildRustPackage rec {
  pname = "regolith-inputd";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "regolith-inputd";
    rev = "v${version}";
    hash = "sha256-PX9lWeAfJ79zEhXEKFTryf780JcoY7k6XRSxzHM1WWw=";
  };

  cargoHash = "sha256-B/lAyjU1vMZKgg+fRvOm0QfVEKyaZHMexvxraI5f17I=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  # postInstall = ''
  #   mkdir -p $out/lib/systemd/user/
  #   install -Dm644 $src/data/regolith-init-inputd.service $out/lib/systemd/user/
  # '';

  meta = {
    description = "Input management daemon for regolith wayland session";
    homepage = "https://github.com/regolith-linux/regolith-inputd";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "regolith-inputd";
  };
}
