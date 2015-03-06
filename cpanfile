requires "Dancer2" => "0.159002";
requires "Dancer2::Session::Simple" => "0.141000"; 

recommends "URL::Encode::XS"    => "0";
recommends "CGI::Deurl::XS"     => "0";
recommends "HTTP::Parser::XS"   => "0";
recommends "YAML::XS"           => "0";

on "test" => sub {
    requires "Test::More"            => "0";
    requires "HTTP::Request::Common" => "0";
};
