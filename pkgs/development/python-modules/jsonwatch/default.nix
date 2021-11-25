{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, isPyPy
}:

buildPythonPackage rec {
  pname = "jsonwatch";
  version = "0.6.0";
  disabled = isPyPy; # doesn't find setuptools

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = "jsonwatch";
    rev = "v${version}";
    sha256 = "0abmyv3nrfqhjmfnvpn4q3yc05a1gamfxj5frlbn1lidzzhb8rac";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Like watch -d but for JSON";
    longDescription = ''
      jsonwatch is a command line utility with which you can track
      changes in JSON data delivered by a shell command or a web
      (HTTP/HTTPS) API.  jsonwatch requests data from the designated
      source repeatedly at a set interval and displays the
      differences when the data changes. It is similar in its
      behavior to how watch(1) with the -d switch works for
      plain-text data.
    '';
    homepage = "https://github.com/dbohdan/jsonwatch";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
