{
    # Fields for validating
    fields => [ qw/nombre precio/ ],
    checks => [
        nombre => is_required("Debe indicarse un nombre"),
		precio => is_required("Debe indicarse el precio"),
    	precio => is_like( qr/^^[-+]?[0-9]*\.?[0-9]+$/, 'El precio ingresado no es valido.' ),
    ],
}

