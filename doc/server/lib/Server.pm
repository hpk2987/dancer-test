package Server;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/presentacion' => sub {
	send_file '/index.html';
};



true;
