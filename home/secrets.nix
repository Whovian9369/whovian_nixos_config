let
  whovian = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKUpUbEtBSySMW82Wm4xOtlGKxnPf8bqKxVMRJH3Sycx";
in
{
  "secrets/openai_key.age".publicKeys = [ whovian ];
  "secrets/curse.age".publicKeys = [ whovian ];
}