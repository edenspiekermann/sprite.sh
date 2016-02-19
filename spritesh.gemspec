require 'json'
package = JSON.parse(IO.read("package.json"))

Gem::Specification.new do |spec|
  spec.name          = package["name"]
  spec.version       = package["version"]
  spec.description   = package["description"]
  spec.homepage      = package["homepage"]
  spec.license       = package["license"]
  spec.summary       = "Build an SVG sprite from a folder of SVG files."
  spec.authors       = ["Hugo Giraudel", "Cade Scroggins"]
  spec.email         = ["h.giraudel@de.edenspiekermann.com", "hello@cadejs.com"]
  spec.files         = ["bin/spritesh", "bin/sprite.sh"]
  spec.executables   = ["spritesh"]
end
