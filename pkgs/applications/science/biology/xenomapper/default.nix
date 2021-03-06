{buildPythonPackage, lib, fetchFromGitHub, statistics}:

buildPythonPackage rec {
  pname = "xenomapper";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "genomematt";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mnmfzlq5mhih6z8dq5bkx95vb8whjycz9mdlqwbmlqjb3gb3zhr";
  };

  propagatedBuildInputs = [ statistics ];

  meta = with lib; {
    homepage = "http://github.com/genomematt/xenomapper";
    description = "A utility for post processing mapped reads that have been aligned to a primary genome and a secondary genome and binning reads into species specific, multimapping in each species, unmapped and unassigned bins";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.jbedo ];
  };
}
