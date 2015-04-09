Paperclip::Attachment.default_options.update({
  s3_host_name: "s3-eu-west-1.amazonaws.com",
  s3_protocol: "", # relative
  url: "/system/:tenant/:class/:attachment_name/:id_partition/:style/:filename",
  path: ":rails_root/public/system/:tenant/:class/:attachment_name/:id_partition/:style/:filename"
});

Paperclip.interpolates :tenant do |attachment, style|
  Apartment::Tenant.current
end

Paperclip.interpolates :attachment_name do |attachment, style|
  attachment.name.to_s.pluralize
end
