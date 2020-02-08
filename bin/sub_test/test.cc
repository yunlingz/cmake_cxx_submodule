#include <iostream>
#include <thread>

#include "example/sub.h"

int main() {
  int result = example::sub(3, 2);
  std::cout << "3 - 2 = " << result << '\n';
  return 0;
}
