Pod::Spec.new do |spec|
    spec.name = "Framezilla"
    spec.version = "0.1"
    spec.summary = "Comfortable syntax for working with frames."
    spec.homepage = "https://github.com/Otbivnoe/Framezilla"
    spec.license = { type: 'MIT', file: 'LICENSE' }
    spec.authors = { "Nikita Ermolenko" => 'gnod94@gmail.com' }
    spec.platform = :ios
    spec.requires_arc = true
    spec.source = { git: "https://github.com/Otbivnoe/Framezilla.git", tag: "spec.version", submodules: true }
    spec.source_files = "Framezilla/**/*.{h,swift}"
end
