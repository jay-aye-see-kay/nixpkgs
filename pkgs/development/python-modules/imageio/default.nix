{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, isPyPy
, substituteAll

# build-system
, setuptools

# native dependencies
, libGL

# dependencies
, numpy
, pillow

# optional-dependencies
, astropy
, av
, imageio-ffmpeg
, pillow-heif
, psutil
, tifffile

# tests
, pytestCheckHook
, fsspec
}:

buildPythonPackage rec {
  pname = "imageio";
  version = "2.33.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "imageio";
    repo = "imageio";
    rev = "refs/tags/v${version}";
    hash = "sha256-WoCycrJxo0vyV9LiWnEag1wbld3EJWu8mks8TnYt2+A=";
  };

  patches = lib.optionals (!stdenv.isDarwin) [
    (substituteAll {
      src = ./libgl-path.patch;
      libgl = "${libGL.out}/lib/libGL${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    pillow
  ];

  passthru.optional-dependencies = {
    bsdf = [];
    dicom = [];
    feisem = [];
    ffmpeg = [
      imageio-ffmpeg
      psutil
    ];
    fits = lib.optionals (!isPyPy) [
      astropy
    ];
    freeimage = [];
    lytro = [];
    numpy = [];
    pillow = [];
    simpleitk = [];
    spe = [];
    swf = [];
    tifffile = [
      tifffile
    ];
    pyav = [
      av
    ];
    heif = [
      pillow-heif
    ];
  };

  nativeCheckInputs = [
    fsspec
    psutil
    pytestCheckHook
  ]
  ++ fsspec.optional-dependencies.github
  ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    "-m 'not needs_internet'"
  ];

  preCheck = ''
    export IMAGEIO_USERDIR="$TMP"
    export HOME=$TMPDIR
  '';

  disabledTestPaths = [
    # tries to fetch fixtures over the network
    "tests/test_freeimage.py"
    "tests/test_pillow.py"
    "tests/test_spe.py"
    "tests/test_swf.py"
  ];

  meta = with lib; {
    description = "Library for reading and writing a wide range of image, video, scientific, and volumetric data formats";
    homepage = "https://imageio.readthedocs.io";
    changelog = "https://github.com/imageio/imageio/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ Luflosi ];
  };
}
