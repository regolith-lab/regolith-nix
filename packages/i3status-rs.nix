{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libpulseaudio
, openssl
, stdenv
, lm_sensors
,
}:

rustPlatform.buildRustPackage rec {
  pname = "i3status-rs-debian";
  version = "0.32.1-1";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "i3status-rs_debian";
    rev = "v${version}";
    hash = "sha256-ZUgdHfXl3Y5XXkZFgTRb2cW9rdv/FpgLoDliSUIYXtI=";
  };

  cargoHash = "sha256-1fpT5BPdmUE8saQED62NlPc6zOVNkaa1zaO7ZIuXnWc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libpulseaudio
    openssl
    lm_sensors
  ];

  postInstall = ''
    mkdir -p $out/etc/regolith/i3status-rust $out/share/i3status-rust/
    cp -r $src/examples/* $out/etc/regolith/i3status-rust
    cp -r $src/files/* $out/share/i3status-rust/
  '';

  meta = {
    description = "I3status-rs packaged for Debian";
    homepage = "https://github.com/regolith-linux/i3status-rs_debian";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "i3status-rs-debian";
  };
}
