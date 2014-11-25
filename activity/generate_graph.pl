#!/usr/bin/perl

use 5.010;
use warnings;
use strict;


use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Renderer::Pie;
use Geometry::Primitive::Rectangle;
use Graphics::Color::RGB;
use File::Slurp;

my $INPUT="/home/manaha-minecrafter/public_html/activity.txt";
my %DATA = read_file( $INPUT ) =~ /^(.+)=(.*)$/mg ;

my $cc = Chart::Clicker->new(width => 600, height => 500);

foreach my $element (keys %DATA){
	$cc->add_data($element, $DATA{$element});
	say "$element - $DATA{$element}";
}

$cc->title->text('Hours Avtive');
$cc->title->font->size(20);

$cc->color_allocator->new({
	seed_hue => 175, #red
});
my $defctx = $cc->get_context('default');
my $ren = Chart::Clicker::Renderer::Pie->new;
$ren->border_color(Graphics::Color::RGB->new(red => 1, green => 1, blue => 1));
$ren->brush->width(2);
$ren->gradient_color(Graphics::Color::RGB->new(red => 1, green => 1, blue => 1, alpha => .3));
$ren->gradient_reverse(1);
$defctx->renderer($ren);
$defctx->domain_axis->hidden(1);
$defctx->range_axis->hidden(1);
$cc->plot->grid->visible(0);

$cc->write_output('../../public_html/pie-gradient.png');
