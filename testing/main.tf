locals {
  test_map = {
    one   = "first value"
    two   = "second value"
    three = "third value"
  }

  test_count = []
}

resource "null_resource" "test" {
    triggers {
      countvar = local.test_count
    }

    count = 0
    
}