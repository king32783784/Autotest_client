# Copyright(c) 2007-2010 by Lorenzo Gil Sanchez <lorenzo.gil.sanchez@gmail.com>
#
# This file is part of PyCha.
#
# PyCha is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# PyCha is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with PyCha.  If not, see <http://www.gnu.org/licenses/>.

import sys

import cairo

import pycha.bar

import os

for arg in sys.argv:
    if arg == 'MORE':
        from chart1 import dataSet
        label={      'TYPE'   : 'Compiler - More is better',
             }
        unit={    'UNIT'     : ' ',
            }
        titles={    'TITLE'    : 'Compiler',
             }
        syscputype = (
            ('npb', 25.694 ),
            ('Ripper-Blowfish', 44.866 ),
            ('x264', 1),
            ('sharpen', 2 ),
            ('Resizing', 3),
            ('HWColor', 4),
            ('7-zip', 5),
            ('OpenSSL', 6),
            ('Apache', 7),
            )
    elif arg == 'LESS':
        from chart2 import dataSet
        label={      'TYPE'   : 'Compiler - Less is better',  
             }
        unit={    'UNIT'    : '',
            }
        titles={    'TITLE'    : 'Compiler',
             }
        syscputype = (
            ('hmmer', 25.694 ),
            ('gcrypt', 44.866 ),
            ('TimedApache', 1),
            ('TimedImageMagick', 2),
            ('Timedphp', 3),
            ('C-ray', 4),
            ('Bullet-Raytests', 5),
            ('Bullet-3000Fall', 6),
            ('Bullet-1000Stack', 7),
            ('Bullet-1000Convex', 8),
            ('Bullet-Convex-Trimesh', 9),
            ('LAME-MP3', 10),
            )

def barChart(output, chartFactory):
    surface = cairo.ImageSurface(cairo.FORMAT_ARGB32,800,400)
   
    options = {
        'axis': {
            'x': {
                'ticks': [dict(v=i, label=l[0]) for i, l in enumerate(syscputype)],
                'label': label['TYPE'],
                'rotate': 25,
            },
            'y': {
                'tickCount': 5,
                'rotate': 5,
                'label': unit['UNIT'],
            }
        },
        'background': {
            'chartColor': '#FFFFFF',
            'baseColor': '#FFFFFF',
            'lineColor': '#ADADAD'
        },
        'colorScheme': {
            'name': 'gradient',
            'args': {
                'initialColor': 'green',
            },
        },
         'legend': {
            'position': {
                'top' : 25,
                'left': 650
                }
            },
        'padding': {
            'left': 0,
            'bottom': 0,
        },
        'title': titles['TITLE'],
    }
    chart = chartFactory(surface, options)

    chart.addDataset(dataSet)
    chart.render()

    surface.write_to_png(output)

if __name__ == '__main__':
    if len(sys.argv) > 2:
        output = sys.argv[1]
    else:
        output = sys.argv[1]
    barChart('comp' + output + '.png', pycha.bar.VerticalBarChart)
   # barChart('h' + output, pycha.bar.HorizontalBarChart)
