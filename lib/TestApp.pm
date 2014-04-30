package TestApp;
use Dancer ':syntax';
use TestApp::Tickets;

get '/tickets' => sub {
    TestApp::Tickets::tickets_list();
};

get '/tickets/:id' => sub {
    TestApp::Tickets::ticket_view(param('id'))
        or status(404), return {};
};

post '/tickets' => sub {
    TestApp::Tickets::ticket_add(params)
        or status(500), return vars->{exception};
};


true;
