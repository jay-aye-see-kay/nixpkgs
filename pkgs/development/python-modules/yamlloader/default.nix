{ lib, buildPythonPackage, fetchPypi
, pytest, pyyaml, hypothesis
}:

buildPythonPackage rec {
  pname = "yamlloader";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NWaf17n4xrONuGGlFwFULEJnK0boq2MlNIaoy4N3toc=";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  checkInputs = [
    hypothesis
    pytest
  ];

  pythonImportsCheck = [
    "yaml"
    "yamlloader"
  ];

  meta = with lib; {
    description = "A case-insensitive list for Python";
    homepage = "https://github.com/Phynix/yamlloader";
    license = licenses.mit;
    maintainers = with maintainers; [ freezeboy ];
  };
}
