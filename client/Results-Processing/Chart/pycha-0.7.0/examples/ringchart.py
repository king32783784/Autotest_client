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

import pycha.ring

lines = (
    ('bar.py', 219, 201, 31),
    ('chart.py', 975, 450, 341),
    ('color.py', 104, 300, 200),
    ('line.py', 230, 100, 450),
    ('pie.py', 452, 100, 304),
    ('scatter.py', 138, 500, 200),
    ('stackedbar.py', 21, 110, 200),
)


def ringChart(output):
    surface = cairo.ImageSurface(cairo.FORMAT_ARGB32, 800, 800)

    dataSet = [(line[0], [[0, line[1]], [1, line[2]], [2, line[3]]])
        for line in lines]

    options = {
        'axis': {
            'x': {
                'ticks': [dict(v=i, label=d) for i, d in
                    enumerate(['2010', '2011', '2012'])],
            }
        },
        'legend': {
            'hide': False,
        },
        'title': 'Ring Chart',
    }
    chart = pycha.ring.RingChart(surface, options)

    chart.addDataset(dataSet)
    chart.render()

    surface.write_to_png(output)

if __name__ == '__main__':
    if len(sys.argv) > 1:
        output = sys.argv[1]
    else:
        output = 'ringchart.png'
    ringChart(output)
