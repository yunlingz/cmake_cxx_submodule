#include <gtest/gtest.h>

TEST(test_1, eq_works) {
  ASSERT_EQ(0, 1 - 1) << "Equality is broken. Mass panic!";
}

TEST(test_1, neq_works) {
  ASSERT_NE(15, 106)
      << "Inequal is equal. The foundations of space and time are in jeopardy.";
}
