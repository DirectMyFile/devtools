part of devtools.util;

void repeat(void function(int i), int times) {
  for (int i = 1; i <= times; i++) function(i);
}