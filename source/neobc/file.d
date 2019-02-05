module neobc.file;
import neobc.array;

version(Windows)
private const char* mmap_file(const char* fileName) {
  HANDLE file =
      CreateFileA(fileName, GENERIC_READ, FILE_SHARE_READ, ptr, OPEN_EXISTING,
                  FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN, ptr);
  assert(file != INVALID_HANDLE_VALUE);

  HANDLE fileMapping = CreateFileMapping(file, ptr, PAGE_READONLY, 0, 0, ptr);
  assert(fileMapping != INVALID_HANDLE_VALUE);

  LPVOID fileMapView = MapViewOfFile(fileMapping, FILE_MAP_READ, 0, 0, 0);
  auto fileMapViewChar = cast(const char*)fileMapView;
  assert(fileMapView != ptr);
}

version(linux)
private void mmap_file(const(char)* fileName, ref Array!(char) fileData) {
  import core.stdc.stdio;
  import core.stdc.stdlib;

  FILE * file = fopen(fileName, "rb");
  if(!file) { printf("Could not open file\n"); return; }
  fseek(file, 0, SEEK_END);
  auto fileLength = ftell(file);
  rewind(file);
  fileData.length = fileLength;
  fread(fileData.ptr, fileLength, 1, file);
  fclose(file);
}

void ReadFile(const(char)* fileName, ref Array!(char) fileData) {
  mmap_file(fileName, fileData);
}
