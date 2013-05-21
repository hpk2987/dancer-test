package MyApp;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::FlashMessage;
use Dancer::Plugin::ValidateTiny;

our $VERSION = '0.1';

get '/' => sub {
	template 'index';
};

my $acc_productos = {
	listar => '/productos',
	agregar => '/productos/agregar',
	modificar => '/productos/modificar',
	eliminar => '/productos/eliminar',
	guardar => '/productos/guardar',
};

get $acc_productos->{'listar'} => sub {
	my @prods = database->quick_select('producto',{});
	
	# No deberia hacer falta pero lo que
	# indica el tutorial de FlashMessage no funciona
	my $msg = {
		error => flash('error'),
		warning => flash('warning'),
		info => flash('info'),
	};

    template 'productos' => {
		productos => [@prods],
		acciones => $acc_productos,
		msg => $msg,
    };
};

post $acc_productos->{'modificar'} => sub{
	my $producto = database->quick_select(
						'producto',
						{id => params->{'id'}});

	# No deberia hacer falta pero lo que
	# indica el tutorial de FlashMessage no funciona
	my $msg = {
		error => flash('error'),
		warning => flash('warning'),
		info => flash('info'),
	};


	template 'producto' => {
		encabezado => 'Modificar producto',
		tipo => 'modificar',
		producto => $producto,
		acciones => $acc_productos,
		msg => $msg,
	}
};

post $acc_productos->{'guardar'} => sub{
	my $vparams = {
		nombre => params->{'nombre'},
		precio => params->{'precio'},
	};
    # Validating params with rule file
    my $data = validator($vparams, 'ValidarProducto.pl');
	my $origen = $acc_productos->{params->{'tipo'}};

	if($data->{valid}){
#		if(exists params->{'id'}){
#			database->quick_update
#				('producto',
#				{id => params->{'id'}},
#				{nombre => params->{'nombre'},
#				 precio => params->{'precio'}});
#		}else{
#			database->quick_insert
#				('producto',
#				{nombre => params->{'nombre'},
#				 precio => params->{'precio'}});
#		}
#
#		flash info => ["El producto se almaceno correctamente"];
#		redirect $acc_productos->{'listar'};
	}else{
		flash warning => [values($data->{'result'})];
		forward $origen;
	}
};

any ['post','get'] => $acc_productos->{'agregar'} => sub{
	# No deberia hacer falta pero lo que
	# indica el tutorial de FlashMessage no funciona
	my $msg = {
		error => flash('error'),
		warning => flash('warning'),
		info => flash('info'),
	};

	template 'producto' =>{
		encabezado => 'Agregar producto',
		tipo => 'agregar',
		acciones => $acc_productos,
		msg => $msg,
	};
};

post $acc_productos->{'eliminar'} => sub{
	database->quick_delete('producto', { id => params->{'id'} });

	flash info => ["El producto se elimino correctamente"];
	redirect $acc_productos->{'listar'};
};

true;
