# Mailhide plugin for Ikiwiki

This plugin provides the directive mailhide, that uses the [Mailhide
API][1] to protect email addresses from spammers.

## Dependencies

The [Captcha::reCAPTCHA::Mailhide][2] perl module is required for this
plugin.

## Download

You can get the source code from [github][3].

## Installation

Copy `imailhide.pm` to `/usr/share/perl/5.10.0/IkiWiki/Plugin` or
`~/.ikiwiki/IkiWiki/Plugin`, and enable it in your `.setup` file

    add_plugins => [qw{goodstuff imailhide ....}],
    mailhide_public_key => "8s99vSA99fF11mao193LWdpa==",
    mailhide_private_key => "6b5e4545326b5e4545326b5e45453223",
    mailhide_default_style => "short",

## Configuration

### `mailhide_public_key`

This is your personal public key that you can get at [Google][4].

### `mailhide_private_key`

This is your personal private key that you can get at [Google][4].

### `mailhide_default_style`

As per the recommendation of the [Mailhide API documentation][5], you
can define this as `short` or `long`. The `short` parameter will
result in `<a href="...">john</a>` links, while the `long` parameter
will result in `joh<a href="...">...</a>@example.com`.

## Parameters

### `email`

*Required.* This is the email addres that you want to hide.

### `style`

*Optional.* You can set the style parameter individually for each
 `mailhide` call. See `mailhide_default_style` for details.

[1]: http://www.google.com/recaptcha/mailhide/
[2]: http://search.cpan.org/perldoc?Captcha::reCAPTCHA::Mailhide
[3]: http://github.com/petervizi/imailhide
[4]: http://www.google.com/recaptcha/mailhide/apikey
[5]: http://code.google.com/apis/recaptcha/docs/mailhideapi.html
