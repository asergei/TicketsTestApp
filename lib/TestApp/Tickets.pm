package TestApp::Tickets;
use warnings;
use strict;
use Dancer::Plugin::Database;
use Dancer ':syntax';

sub tickets_list {
    database->selectall_arrayref(<<SQL, { Slice => {} });
select
    t.id,
    s.name,
    u.name,
    t.updated,
    t.subject
from
    tickets t
    left join tickets_status s on s.id = t.status
    left join users u on u.id = t.sender
order by
    updated desc
SQL
    
}

sub ticket_add {
    my %param = @_;
    
    my $dbh = database;
    my %validate = (
        sender  => sub {
            $_[0] and $dbh->quick_lookup('users', { id => $_[0] }, 'id');
        },
        status  => sub {
            $_[0] and $dbh->quick_lookup('tickets_status', { id => $_[0] }, 'id');
        },
        subject => sub { $_[0] and length $_[0] <= 255 },
        content => sub { $_[0] and length $_[0] <= 65546 },
    );
    
    if ( my @bad_fields = grep { not $validate{$_}($param{$_}) } keys %validate ) {
        vars->{exception} = 'Check input values in fields: ' . join ', ', @bad_fields;
        return;
    }
    
    local $@;
    eval {
        $dbh->quick_insert('tickets', {
            map { $_ => $param{$_} } qw(sender status subject content)
        });
    };
    if ($@) {
        vars->{exception} = 'Unknown';
        return;
    }
    
    { id => $dbh->{mysql_insertid} };
}

sub ticket_view {
    my $id = shift;
    database->selectrow_hashref(<<SQL, undef, $id);
select
    t.id,
    s.name,
    u.name,
    t.updated,
    t.subject,
    t.content
from
    tickets t
    left join tickets_status s on s.id = t.status
    left join users u on u.id = t.sender
where
    t.id = ?
SQL
    
}



1;