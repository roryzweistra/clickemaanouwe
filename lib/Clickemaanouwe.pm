package Clickemaanouwe;
use Dancer2;
use Image::Thumbnail;
use Digest::MD5 'md5';

our $VERSION = '0.1';

hook 'before' => sub {
    # Check if authorised for viewing, if not redirect to login.
    if ( ( not session( 'authorised' ) ) && ( request->path_info ne '/login' ) ) {
        redirect '/login';
    }
};

get '/' => sub {
    my $dirname = config->{ 'uploads_dir' } . '/thumbs';
    opendir my($dh), $dirname or die "Couldn't open dir '$dirname': $!";
    my @files = grep { !/^\./ } readdir $dh;
    closedir $dh;

    template 'index', { 'files' => \@files };
};

get '/login' => sub {
    template 'login';
};

post '/login' => sub {
    my $username    = params->{ 'username' };
    my $password    = params->{ 'password' };

    if ( ( $username eq config->{ 'username' } ) && ( $password eq config->{ 'password' } ) ) {
        session 'authorised'    => 1;
    }

    redirect '/';
};

get '/uploads/:file' => sub {
    my $path = config->{ 'uploads_dir' } . '/' . param 'file';

    return send_file ( $path, system_path => 1 );
};

get '/uploads/thumbs/:file' => sub {
    my $path = config->{ 'uploads_dir' } . '/thumbs/' . param 'file';
    return send_file( $path, system_path => 1 );
};

post '/upload' => sub {
    use Data::Dumper;
    my $upload_dir  = config->{ 'uploads_dir' };
    my $uploads     = request->uploads;
    my @files;

    if ( ref( $uploads->{ 'file' } ) eq 'ARRAY' ) {
        @files = @{ $uploads->{ 'file' } };
    }
    else {
        push @files, $uploads->{ 'file' };
    }

    foreach my $file ( @files ) {
        # Sanitize filename
        my $filename    = lc $file->filename;
        $filename       =~ s/\s/-/g;
        $filename       = time . '-' . $filename;
        # Save file.
        my $path = $upload_dir . '/' . $filename;
        $file->copy_to( $path );

        # Create thumb
        my $t = new Image::Thumbnail(
            module     => "Image::Magick",
            size       => 100,
            create     => 1,
            input      => $path,
            outputpath => $upload_dir . '/thumbs/' . $filename,
        );
    }

    return redirect '/';
};

true;
