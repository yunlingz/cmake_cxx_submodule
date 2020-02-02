#include "example/sub.h"

#include "example_inner/add.h"

namespace example {

int sub(const int& x, const int& y) { return add(x, -y); }

int TMPC::sub(const int& x, const int& y) {
  return add(x, -y);
}

}  // namespace example
