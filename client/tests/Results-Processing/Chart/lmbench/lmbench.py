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
    if arg == 'PROCESS1':
        from chart1 import dataSet
        label={      'TYPE'   : 'Processor, Processes - times in microseconds - smaller is better',
             }
        unit={    'UNIT'     : 'Usec',
            }
        titles={    'TITLE'    : 'Processor, Processes',
             }
        lmbenchtype = (
            ('null call', 25.694 ),
            ('null I/O', 44.866 ),
            ('stat', 1),
            ('open clos', 2),
            ('slct TCP', 3),
            ('sig inst', 4),
            ('sig hndl', 5),
            )
    elif arg == 'PROCESS2':
        from chart12 import dataSet
        label={      'TYPE'   : 'Processor, Processes - times in microseconds - smaller is better',
             }
        unit={    'UNIT'     : 'Usec',
            }
        titles={    'TITLE'    : 'Processor, Processes',
             }
        lmbenchtype = (
            ('fork proc', 6),
            ('exec proc', 7),
            ('sh proc', 8),
            )
    elif arg == 'INT':
        from chart2 import dataSet
        label={      'TYPE'   : 'Basic integer operations - times in nanoseconds - smaller is better',  
             }
        unit={    'UNIT'    : 'Nsec',
            }
        titles={    'TITLE'    : 'Basic Integer Operations',
             }
        lmbenchtype = (
            ('intgr bit', 25.694 ),
            ('intgr add', 44.866 ),
            ('intgr mul', 1),
            ('intgr div', 2),
            ('intgr mod', 3),
            )
    elif arg == 'UINT':
        from chart3 import dataSet
        label={      'TYPE'   : 'Basic uint64 operations - times in nanoseconds - smaller is better',
             }
        unit={    'UNIT'    : 'Nsec',
            }
        titles={    'TITLE'    : 'Basic Uint64 Operations',
             }
        lmbenchtype = (
            ('int64 bit', 25.694 ),
            ('int64 add', 44.866 ),
            ('int64 mul', 1),
            ('int64 div', 2),
            ('int64 mod', 3),
            )
    elif arg == 'FLOAT':
        from chart4 import dataSet
        label={      'TYPE'   : 'Basic float operations - times in nanoseconds - smaller is better',
             }
        unit={    'UNIT'    : 'Nsec',
            } 
        titles={    'TITLE'    : 'Basic Float Operations',
             }
        lmbenchtype = (
            ('float add', 25.694 ),
            ('float mul', 44.866 ),
            ('float div', 1),
            ('float bogo', 2),
            )
    elif arg == 'DOUBLE':
        from chart5 import dataSet
        label={      'TYPE'   : 'Basic double operations - times in nanoseconds - smaller is better',
             }
        unit={    'UNIT'    : 'Nsec',
            }
        titles={    'TITLE'    : 'Basic Double Operations',
             }
        lmbenchtype = (
            ('double add', 25.694 ),
            ('double mul', 44.866 ),
            ('double div', 1),
            ('double bogo', 2),
            )
    elif arg == 'CONTEXT':
        from chart6 import dataSet
        label={      'TYPE'   : 'Context switching - times in microseconds - smaller is better',
             }
        unit={    'UNIT'    : 'Usec',
            }
        titles={    'TITLE'    : 'Context Switching',
             }
        lmbenchtype = (
            ('2p/0K ctxsw', 25.694 ),
            ('2p/16K ctxsw', 44.866 ),
            ('2p/64K ctxsw', 1),
            ('8p/16K ctxsw', 2),
            ('8p/64K ctxsw', 3),
            ('16p/16K ctxsw', 4),
            ('16p/64K ctxsw', 5),
            )
    elif arg == 'LATENCY':
        from chart7 import dataSet
        label={      'TYPE'   : '*Local* Communication latencies in microseconds - smaller is better',
             }
        unit={    'UNIT'    : 'Usec',
            }
        titles={    'TITLE'    : '*Local* Communication Latencies',
             }
        lmbenchtype = (
            ('2p/0K ctxsw', 25.694 ),
            ('Pipe', 44.866 ),
            ('AF UNIX', 1),
            ('UDP', 2),
            ('RPC/UDP', 3),
            ('TCP', 4),
            ('RPC/TCP', 5),
            ('TCP conn', 6),
            )
    elif arg == 'REMOTE':
        from chart8 import dataSet
        label={      'TYPE'   : '*Remote* Communication latencies in microseconds - smaller is better',
             }
        unit={    'UNIT'    : 'Usec',
            }
        titles={    'TITLE'    : '*Remote* Communication Latencies',
             }
        lmbenchtype = (
            ('UDP', 25.694 ),
            ('RPC/UDP', 44.866 ),
            ('TCP', 1),
            ('RPC/TCP', 2),
            ('TCP conn', 3),
            )
    elif arg == 'FILEVM':
        from chart9 import dataSet
        label={      'TYPE'   : 'File & VM system latencies in microseconds - smaller is better',
             }
        unit={    'UNIT'    : 'Usec',
            }
        titles={    'TITLE'    : 'File & VM System Latencies',
             }
        lmbenchtype = (
            ('0K File Create', 25.694 ),
            ('0K File Delete', 44.866 ),
            ('10K File Create', 1), 
            ('10K File Delete', 2),
            ('Mmap Latency', 3),
            ('Prot Fault', 4),
            ('Page Fault', 5),
            ('100fd selct', 6),
            )
    elif arg == 'BANDWIDTH':
        from chart10 import dataSet
        label={      'TYPE'   : '*Local* Communication bandwidths in MB/s - bigger is better',
             }
        unit={    'UNIT'    : 'MB/s',
            }
        titles={    'TITLE'    : '*Local* Communication Bandwidths',
             }
        lmbenchtype = (
            ('Pipe', 25.694 ),
            ('AF UNIX', 44.866 ),
            ('TCP', 1),
            ('File reread', 2),
            ('Mmap reread', 3),
            ('Bcopy(libc)', 4),
            ('Bcopy(hand)', 5),
            ('Mem read', 6),
            ('Mem write', 7),
            )
    elif arg == 'MEMORY':
        from chart11 import dataSet
        label={      'TYPE'   : 'Memory latencies in nanoseconds - smaller is better',
             }
        unit={    'UNIT'    : 'Nsec',
            }
        titles={    'TITLE'    : 'Memory Latencies',
             }
        lmbenchtype = (
            ('L1 $', 25.694 ),
            ('L2 $', 44.866 ),
            ('Main mem', 1),
            ('Rand mem', 2),
            ('Guesses', 3),
            )
def barChart(output, chartFactory):
    surface = cairo.ImageSurface(cairo.FORMAT_ARGB32,800,400)
   
    options = {
        'axis': {
            'x': {
                'ticks': [dict(v=i, label=l[0]) for i, l in enumerate(lmbenchtype)],
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
                'left': 700
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
    barChart('LM' + output + '.png', pycha.bar.VerticalBarChart)
   # barChart('h' + output, pycha.bar.HorizontalBarChart)
