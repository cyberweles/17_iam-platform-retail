output "group_ids" {
  value = {
    for name, g in azuread_group.groups : name => g.id
  }
}

output "group_display_names" {
  value = {
    for name, g in azuread_group.groups : name => g.display_name
  }
}
