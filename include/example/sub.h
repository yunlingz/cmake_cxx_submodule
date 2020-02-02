#include "example_inner/add.h"
#include <iostream>

namespace example {

int sub(const int& x, const int& y);
// int sub(const int& x, const int& y) { return add(x, -y); }

class TMPC {
public:
  explicit TMPC() {
    std::cout << add_one(13) << '\n';
  }
  virtual ~TMPC() = default;
  int sub(const int& x, const int& y);
};

}  // namespace example
