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
        label={      'TYPE'   : 'Graphics - More is better',
             }
        unit={    'UNIT'     : 'Frames/second',
            }
        titles={    'TITLE'    : 'Graphics',
             }
        syscputype = (
            ('qgears2', 25.694 ),
            ('doom3', 1),
            ('etqw', 2),
            ('lightsmark', 3),
            ('nexuiz', 4),
            ('prey', 5),
            ('sanctuary', 6),
            ('tropics', 7),
            ('vdrift', 8),
            )
    elif arg == 'LESS':
        from chart2 import dataSet
        label={      'TYPE'   : 'Graphics - Less is better',  
             }
        unit={    'UNIT'    : 'seconds',
            }
        titles={    'TITLE'    : 'Graphics',
             }
        syscputype = (
            ('gtkperf', 25.694 ),
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
    barChart('graph' + output + '.png', pycha.bar.VerticalBarChart)
   # barChart('h' + output, pycha.bar.HorizontalBarChart)
