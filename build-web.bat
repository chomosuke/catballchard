CD frontend
CALL flutter build web
CD ..
RD /S /Q "build"
MD "build"
COPY "frontend\build\web" "build"
