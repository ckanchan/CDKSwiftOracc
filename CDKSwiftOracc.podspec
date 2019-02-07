Pod::Spec.new do |s|2
  
  s.name         = "CDKSwiftOracc"
  s.version      = "0.7.3"
  s.summary      = "Cuneiform documents for Swift"
  
  s.description  = <<-DESC
  This package is a Swift implementation of the Open Richly Annotated Cuneiform Corpus ("Oracc")  schemas for encoding cuneiform texts. In particular, it seeks to provide:
  - Easy to use Swift types to work with signs, words, texts and glossaries
  - Codable types compatible with Oracc JSON open data
  - Catalogue types compatible with Oracc-defined datasets
  - Methods to provide plain-text, HTML, or NSAttributedString output for cuneiform, transliteration and normalisation
  DESC
  
  s.homepage     = "https://github.com/ckanchan/CDKSwiftOracc"
  s.license      = { :type => "GPLv3"}
  s.author    = "Chaitanya Kanchan"
  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.11"
  s.source       = { :git => "https://github.com/ckanchan/CDKSwiftOracc.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/CDKSwiftOracc/**/*.swift"
  s.swift_version = "4.2"
  
end
