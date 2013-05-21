package Producto;

sub crear{
	my $type = shift;
	my %params = @_;
	my $self = {
		nombre => $params{nombre},
		precio => $params{precio},
	};
	return bless $self,$type;
}

sub precio{
	$self = shift;
	return $self->{precio};
}

sub nombre{
	$self = shift;
	return $self->{nombre};
}

1;
