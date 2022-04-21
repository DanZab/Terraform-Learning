# Terraform-Learning
Repository I'm using as I teach myself Terraform


## What I'm experimenting with
`terraform init -from-module='../modules/my-module'`

This command copies the module from the path specified into a new directory and then initializes that directory.

### Remote State Files
You can specify terraform to use a remote state (or another local directory in my case) within the provider block:

``` terraform
terraform {
  backend "local" {
    path = "../../state/terraform.tfstate"
  }
}
```

Using a state file from another source-
  - keeps track of any resources deployed using the same state file
  - allows you to use any outputs provided by any modules that share/were deployed using that state file

Once I configured the remote state, I had to change how I was running plan/apply. If you are using a state file like mine that contained a vnet, subnet, and resource group deployed from another terraform directory, when you try to plan/apply a new resource from somewhere else it will evaluate that state file, see that those other resources aren't in your current deployment and mark them to be deleted.

The fix for this is using the `-target` parameter: `terraform plan -target='azurerm_resource_group.my_resource_group'` (obviously you are referencing the resource or module block from your current directory).

This only evaluates the changes to that resource block and ignores the other elements from the state file.

### Remote State in Automation
Assuming you want to avoid the potentially messy scripting required to update your modules with a find/replace or other manipulation, you need to find a way to update the path to the state file without editing the terraform block in main.tf.

This can be done using [partial backend configuration](https://www.terraform.io/language/settings/backends/configuration#partial-configuration) in the `terraform init` command.

I still need to test this but I would assume this would work in a new directory by running `terraform init -from-module='../modules/my-module/' -backend-config='path=../state/mystate.tfstate'`.

### Accessing Outputs from the Remote State
So assuming you have a remote state file that already has a resource group in it and you need the id of that resource group to create your vm.

My first thought was to use the `data "terraform_remote_state" "mystate" {}` data block to reference the remote state file and then reference that block to get the id being outputted. Unfortunately this doesn't work, as the plan/apply will lock that state file when running which prevents the data block from accessing it.

However, assuming you are running this in automation, you can access those outputs prior to running your plan and then find a way to insert them into your tfvars file.

This can be done using `terraform output` which automatically reads the outputs from the state file referenced in the current directory. You can even fetch just the output values by using the `-raw` parameter. For example, if I only needed the 'resource_group_id' output from the current state I could use:

`terraform output -raw resource_group_id`

And then capture/use that data from my runner to save it to the tfvars file.