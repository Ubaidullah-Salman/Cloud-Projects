version: 0.2
phases:
  install:
    runtime-versions:
      python: 3.11
    commands:
      - cd flask-cicd-app
      - pip install -r requirements.txt
  pre_build:
    commands:
      - cd flask-cicd-app
      - echo Running tests....
      - pytest tests/
  build:
    commands:
      - echo Build complete
artifacts:
  files:
    - '**/*'
  base-directory: flask-cicd-app
