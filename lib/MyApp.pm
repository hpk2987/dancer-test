package MyApp;
use Producto;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
	template 'index';
};

get '/productos' => sub {
    my $prod1 = crear Producto(nombre=>'gaseosa',precio=>10.20);
    my $prod2 = crear Producto(nombre=>'pan',precio=>5.10);
    template 'productos' => {
	productos => [$prod1,$prod2]
    };
};

true;
