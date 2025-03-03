{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, isPyPy
, lazy-object-proxy
, setuptools
, typing-extensions
, typed-ast
, pylint
, pytestCheckHook
, wrapt
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "2.14.2"; # Check whether the version is compatible with pylint
  format = "pyproject";

  disabled = pythonOlder "3.7.2";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-SIBzn57UNn/sLuDWt391M/kcCyjCocHmL5qi2cSX2iA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    lazy-object-proxy
    wrapt
  ] ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ] ++ lib.optionals (!isPyPy && pythonOlder "3.8") [
    typed-ast
  ];

  nativeCheckInputs = [
    pytestCheckHook
    typing-extensions
  ];

  disabledTests = [
    # DeprecationWarning: Deprecated call to `pkg_resources.declare_namespace('tests.testdata.python3.data.path_pkg_resources_1.package')`.
    "test_identify_old_namespace_package_protocol"
  ];

  passthru.tests = {
    inherit pylint;
  };

  meta = with lib; {
    changelog = "https://github.com/PyCQA/astroid/blob/${src.rev}/ChangeLog";
    description = "An abstract syntax tree for Python with inference support";
    homepage = "https://github.com/PyCQA/astroid";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
  };
}
