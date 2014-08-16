part of devtools.util;

void repeatFunction(void function(int i), int times) {
  for (int i = 1; i <= times; i++) function(i);
}
