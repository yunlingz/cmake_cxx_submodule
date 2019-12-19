#include "example/sub.h"

#include "example/add.h"

namespace example {

int sub(const int& x, const int& y) { return add(x, -y); }

}  // namespace example
