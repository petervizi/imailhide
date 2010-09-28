package IkiWiki::Plugin::imailhide;
use warnings;
use strict;
use IkiWiki 3.00;
use Captcha::reCAPTCHA::Mailhide;
use HTML::Tiny;

sub import {
    hook(type => "getsetup", id => "imailhide", call => \&getsetup);
    hook(type => "preprocess", id => "mailhide", call => \&preprocess);
}

sub getsetup () {
    return plugin => {
	safe => 1,
	rebuild => 1,
	section => "other",
    },
    mailhide_public_key => {
	type => "string",
	example => "8s99vSA99fF11mao193LWdpa==",
	description => "Mailhide API public key.",
	safe => 1,
	rebuild => 1,
    },
    mailhide_private_key => {
	type => "string",
	example => "6b5e4545326b5e4545326b5e45453223",
	description => "Mailhide API private key.",
	safe => 1,
	rebuild => 1,
    },
    mailhide_default_style => {
	type => "string",
	example => "long",
	description => "The default style to display protected email address.",
	safe => 1,
	rebuid => 1,
    },
}

my $m = Captcha::reCAPTCHA::Mailhide->new;
my $h = HTML::Tiny->new();

sub preprocess (@) {
    my %params = @_;
    my $email = $params{email};
    my $target = $config{mailhide_default_target};
    my $style = $config{mailhide_default_style};
    my $name = '';

    if (!$email) {
	error "email address is not given for mailhide";
    }
    my $url = $m->mailhide_url($config{mailhide_public_key}, $config{mailhide_private_key}, $email);
    if ($params{style}) {
	$style = $params{style};
    }
    if ($style eq "long") {
	my ( $user, $dots, $at, $dom ) = _longemail_parts( $email );
	return join('',
		    $h->entity_encode( $user ),
		    $h->a(
			{
			    href    => $url,
			    target  => '_blank',
			    title   => 'Reveal this e-mail address'
			},
			$dots
		    ),
		    $at,
		    $h->entity_encode( $dom )
	    );
    } elsif ($style eq "short") {
	my ( $user, $dots, $at, $dom ) = _shortemail_parts( $email );
	return join('',
		    $h->a(
			{
			    href    => $url,
			    target  => '_blank',
			    title   => 'Reveal this e-mail address'
			},
			$h->entity_encode( $user ),
		    )
	    );
    } else {
	error "style ".$style." not supported";
    }
}

sub _longemail_parts {
    my ( $user, $dom ) = split( /\@/, shift, 2 );
    my $ul = length( $user );
    return ( substr( $user, 0, $ul <= 4 ? 1 : $ul <= 6 ? 3 : 4 ),
	     '...', '@', $dom );
}

sub _shortemail_parts {
    my ( $user, $dom ) = split( /\@/, shift, 2 );
    return ( $user, '...', '@', $dom );
}

1;
