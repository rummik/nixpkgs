{ stdenv, fetchFromGitHub, fetchpatch, libjpeg, cmake, autoreconfHook }:

let

  common =
    { version, sha256, patches ? [] }:

    stdenv.mkDerivation rec {
      inherit version patches;

      pname = "jasper";

      src = fetchFromGitHub {
        inherit sha256;
        repo = "jasper";
        owner = "mdadams";
        rev = "version-${version}";
      };

      nativeBuildInputs =
        if (stdenv.lib.versionAtLeast version "2.0.0")
        then
          [ cmake ]
        else
          [ autoreconfHook ];

      propagatedBuildInputs = [ libjpeg ];

      configureFlags = [ "--enable-shared" ];

      outputs = [ "bin" "dev" "out" "man" ];

      enableParallelBuilding = true;

      doCheck = false; # fails

      postInstall = ''
        moveToOutput bin "$bin"
      '';

      meta = with stdenv.lib; {
        homepage = https://www.ece.uvic.ca/~frodo/jasper/;
        description = "JPEG2000 Library";
        platforms = platforms.unix;
        license = licenses.jasper;
        maintainers = with maintainers; [ pSub ];
      };
    };

in

{
  jasper = common {
    version = "2.0.16";
    sha256 = "05l75yd1zsxwv25ykwwwjs8961szv7iywf16nc6vc6qpby27ckv6";

    patches = [
      (fetchpatch {
        name = "CVE-2018-9055.patch";
        url = "http://paste.opensuse.org/view/raw/330751ce";
        sha256 = "0m798m6c4v9yyhql7x684j5kppcm6884n1rrb9ljz8p9aqq2jqnm";
      })
    ];
  };

  jasper_1_900 = common {
    version = "1.900.28";
    #sha256 = "1xv32769qf8977hb813n5wjsrvh0cinshsg8c7p8gcf54zi38hvr";
    sha256 = "0c0fli6gkpsa156hm7ngmj6g9id2yk8xwjpipjkpz49r0xkq638r";
  };
}
