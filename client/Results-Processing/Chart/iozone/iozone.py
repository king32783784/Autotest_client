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

from chart import dataSet

def barChart(output, chartFactory):
    surface = cairo.ImageSurface(cairo.FORMAT_ARGB32,800,400)
   
    syscputype = (
        ('Write', 1),
        ('Rewrite', 2 ),
        ('Read', 3 ),
        ('Reread', 4),
        ('Rondom read', 5),
        ('Rondom write', 6),
    )
    options = {
        'axis': {
            'x': {
                'ticks': [dict(v=i, label=l[0]) for i, l in enumerate(syscputype)],
                'label': 'Value -Kbytes/s- bigger is better',
                'rotate': 25,
            },
            'y': {
                'tickCount': 5,
                'rotate': 5,
                'label': 'Kbytes/s'
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
                'left': 700
                }
            },
        'padding': {
            'left': 0,
            'bottom': 0,
        },
        'title': 'Iozone -Performance Test of File I/O'
    }
    chart = chartFactory(surface, options)

    chart.addDataset(dataSet)
    chart.render()

    surface.write_to_png(output)

if __name__ == '__main__':
    if len(sys.argv) > 1:
        output = sys.argv[1]
    else:
        output = 'iozone.png'
    barChart('v' + output, pycha.bar.VerticalBarChart)
   # barChart('h' + output, pycha.bar.HorizontalBarChart)
