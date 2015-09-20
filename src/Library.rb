
module Hellolisp

  Library = {
    :'t'   => true,
    :'nil' => nil,
    :'car' => -> (x) { x[0][0] },
    :'cdr' => -> (x) { x[0][1..-1] },
    :'+' => -> (x) { x.reduce(&:+) },
    :'-' => -> (x) { x.reduce(&:-) },
    :'*' => -> (x) { x.reduce(&:*) },
    :'/' => -> (x) { x.reduce(&:/) },
    :'print' => -> (x) { x.each { |e| p e } ; x.last }
  }

end
