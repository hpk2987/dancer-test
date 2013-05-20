package MyApp;
use Dancer;

set 'template' => 'tiny';

get '/' => sub {
	send_file '/index.html';
};

get '/productos' => sub {
    template 'productos' => {
			'content' => 'ninguno todavia'
	};
};
