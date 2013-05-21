package MyApp;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::FlashNote;
use Dancer::Plugin::ValidateTiny;

#version de la aplicacion
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

    template 'productos' => {
		productos => [@prods],
		acciones => $acc_productos,
    };
};

post $acc_productos->{'modificar'} => sub{
	return forward $acc_productos->{'agregar'},params,{method => 'POST'};
};

post $acc_productos->{'guardar'} => sub{
	my $vparams = {
		nombre => params->{'nombre'},
		precio => params->{'precio'},
	};
    # Validating params with rule file
    my $data = validator($vparams, 'ValidarProducto.pl');

	if($data->{valid}){
		if(exists params->{'id'}){
			database->quick_update
				('producto',
				{id => params->{'id'}},
				{nombre => params->{'nombre'},
				 precio => params->{'precio'}});
		}else{
			database->quick_insert
				('producto',
				{nombre => params->{'nombre'},
				 precio => params->{'precio'}});
		}

		flash info => "El producto se almaceno correctamente";
		redirect $acc_productos->{'listar'};
	}else{
		while ( (my $key,my $value) = each $data->{'result'} ){	
			# Solo interesan los errores no los valores ingresados
			if($key =~ /^err_/){
				flash warning => $value;
			}
		}
		# Podrian devolverse los params para que no se pierda lo ingresado
		forward $acc_productos->{'agregar'},{params};
	}
};

any ['post','get'] => $acc_productos->{'agregar'} => sub{
	if(params->{'id'} && is_post()){
		my $producto = database->quick_select(
						'producto',
						{id => params->{'id'}});

		template 'producto' => {
			encabezado => 'Modificar producto',
			producto => $producto,
			acciones => $acc_productos,
		}
	}else{
		my $producto = params;

		template 'producto' =>{
			encabezado => 'Agregar producto',
			producto => $producto,
			acciones => $acc_productos,
		};
	}
};

post $acc_productos->{'eliminar'} => sub{
	database->quick_delete('producto', { id => params->{'id'} });

	flash info => "El producto se elimino correctamente";
	redirect $acc_productos->{'listar'};
};

true;
