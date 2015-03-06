package Clickemaanouwe;
use Dancer2;

our $VERSION = '0.1';

hook 'before' => sub {
    # Check if authorised for viewing, if not redirect to login.
    if ( ( not session( 'authorised' ) ) && ( request->path_info ne '/login' ) ) {
        redirect '/login';
    }
};

get '/' => sub {
    template 'index';
};

get '/login' => sub {
    template 'login';
};

post '/login' => sub {
    my $username    = params->{ 'username' };
    my $password    = params->{ 'password' };

    if ( ( lc $username eq 'clicker' ) && ( $password eq 'Cl1ck1tY' ) ) {
        session 'authorised'    => 1;
    }

    redirect '/';
};

post '/upload' => sub {
    use Data::Printer;
    debug p params;
    my $upload_dir  = 'clickemaanouwe/photos';

    my $filename = params->{ 'file' };

    debug 'file: ' . p $filename;
    my @photos = request->upload( $filename );

    debug p @photos;
};

true;
