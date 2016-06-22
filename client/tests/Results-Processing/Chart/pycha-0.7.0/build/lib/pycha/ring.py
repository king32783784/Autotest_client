# Copyright(c) 2007-2010 by Roberto Garcia Carvajal <roberpot@gmail.com>
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

import math

import cairo

from pycha.chart import Chart, Option, Layout, Area, get_text_extents
from pycha.color import hex2rgb


class RingChart(Chart):

    def __init__(self, surface=None, options={}, debug=False):
        super(RingChart, self).__init__(surface, options, debug)
        self.slices = {}
        self.centerx = 0
        self.centery = 0
        self.layout = RingLayout(self.slices)
        self.rings = []
        self.nrings = 0
        self.dataset_names = []
        self.dataset_order = {}

    def _updateChart(self):
        """Evaluates measures for pie charts"""
        self.rings = [i
                      for i in set(
                      [data[0]
                        for dataset in self.datasets
                        for data in dataset[1]])]

        self.nrings = len(self.rings)

        self.dataset_names = [i for i in
                              set([data[0] for data in self.datasets])]
        self.dataset_order = {val: i
            for i, val in enumerate(self.dataset_names)}

        slices = {i: list() for i in self.rings}

        for dataset in self.datasets:
            dataset_name = dataset[0]
            for data in dataset[1]:
                dataset_order = data[0]
                dataset_value = data[1]
                slices[dataset_order].append(
                    dict(name=dataset_name, value=dataset_value))

        s = dict()

        for i in self.rings:
            s[i] = float(sum(slice['value'] for slice in slices[i]))

        for i in self.rings:
            fraction = angle = 0.0
            self.slices[i] = list()
            for slice in slices[i]:
                if slice['value'] > 0:
                    angle += fraction
                    fraction = slice['value'] / s[i]
                    self.slices[i].append(
                        Slice(slice['name'], fraction, i, slice['value'],
                        angle))

    def _updateTicks(self):
        """Evaluates pie ticks"""
        self.xticks = []
        lookups = [key for key in self.slices.keys()]
        if self.options.axis.x.ticks:
            ticks = [tick['v'] for tick in self.options.axis.x.ticks]
            if frozenset(lookups) != frozenset(ticks):
                #TODO: Is there better option than ValueError?
                raise ValueError(u"Incompatible ticks")
            for tick in self.options.axis.x.ticks:
                if not isinstance(tick, Option):
                    tick = Option(tick)
                label = tick.label or str(tick.v)
                self.xticks.append((tick.v, label))
        else:
            for i in lookups:
                self.xticks.append((i, u"%s" % i))

    def _renderLines(self, cx):
        """Aux function for _renderBackground"""
        # there are no lines in a Pie Chart

    def _renderChart(self, cx):
        """Renders a pie chart"""
        self.centerx = self.layout.chart.x + self.layout.chart.w * 0.5
        self.centery = self.layout.chart.y + self.layout.chart.h * 0.5

        cx.set_line_join(cairo.LINE_JOIN_ROUND)

        if self.options.stroke.shadow and False:
            cx.save()
            cx.set_source_rgba(0, 0, 0, 0.15)

            cx.new_path()
            cx.move_to(self.centerx, self.centery)
            cx.arc(self.centerx + 1, self.centery + 2,
                   self.layout.radius + 1, 0, math.pi * 2)
            cx.line_to(self.centerx, self.centery)
            cx.close_path()
            cx.fill()
            cx.restore()

        cx.save()
        self.rings.reverse()
        radius = self.layout.radius
        radius_dec = radius / (self.nrings + 1)
        for i in self.rings:
            slices = self.slices[i]
            for slice in slices:
                if slice.isBigEnough():
                    cx.set_source_rgb(*self.colorScheme[slice.name])
                    if self.options.shouldFill:
                        slice.draw(cx, self.centerx, self.centery,
                                   radius)
                        cx.fill()

                    if not self.options.stroke.hide:
                        slice.draw(cx, self.centerx, self.centery,
                                   radius)
                        cx.set_line_width(self.options.stroke.width)
                        cx.set_source_rgb(*hex2rgb(self.options.stroke.color))
                        cx.stroke()
            radius = radius - radius_dec

        cx.new_path()
        cx.move_to(self.centerx, self.centery)
        cx.arc(self.centerx, self.centery, radius, 0, 360)
        cx.close_path()
        cx.set_line_width(self.options.stroke.width)
        cx.set_source_rgb(*hex2rgb(self.options.stroke.color))
        cx.fill()
        cx.stroke()

        cx.restore()

        if self.debug:
            cx.set_source_rgba(1, 0, 0, 0.5)
            px = max(cx.device_to_user_distance(1, 1))
            for x, y in self.layout._lines:
                cx.arc(x, y, 5 * px, 0, 2 * math.pi)
                cx.fill()
                cx.new_path()
                cx.move_to(self.centerx, self.centery)
                cx.line_to(x, y)
                cx.stroke()

    def _renderAxis(self, cx):
        """Renders the axis for pie charts"""
        if self.options.axis.x.hide or not self.xticks:
            return

        self.xlabels = []

        if self.debug:
            px = max(cx.device_to_user_distance(1, 1))
            cx.set_source_rgba(0, 0, 1, 0.5)
            for x, y, w, h in self.layout.ticks:
                cx.rectangle(x, y, w, h)
                cx.stroke()
                cx.arc(x + w / 2.0, y + h / 2.0, 5 * px, 0, 2 * math.pi)
                cx.fill()
                cx.arc(x, y, 2 * px, 0, 2 * math.pi)
                cx.fill()

        cx.select_font_face(self.options.axis.tickFont,
                            cairo.FONT_SLANT_NORMAL,
                            cairo.FONT_WEIGHT_NORMAL)
        cx.set_font_size(self.options.axis.tickFontSize)

        cx.set_source_rgb(*hex2rgb(self.options.axis.labelColor))

        radius = self.layout.radius
        radius_inc = radius / (self.nrings + 1)
        current_radius = self.centery + radius_inc + radius_inc / 2

        for i, tick in enumerate(self.xticks):
            label = tick[1]
            cx.move_to(self.centerx, current_radius)
            cx.show_text(label)
            current_radius += radius_inc


class Slice(object):

    def __init__(self, name, fraction, xval, yval, angle):
        self.name = name
        self.fraction = fraction
        self.xval = xval
        self.yval = yval
        self.startAngle = 2 * angle * math.pi
        self.endAngle = 2 * (angle + fraction) * math.pi

    def __str__(self):
        return ("<pycha.pie.Slice from %.2f to %.2f (%.2f%%)>" %
                (self.startAngle, self.endAngle, self.fraction))

    def isBigEnough(self):
        return abs(self.startAngle - self.endAngle) > 0.001

    def draw(self, cx, centerx, centery, radius):
        cx.new_path()
        cx.move_to(centerx, centery)
        cx.arc(centerx, centery, radius, -self.endAngle, -self.startAngle)
        cx.close_path()

    def getNormalisedAngle(self):
        normalisedAngle = (self.startAngle + self.endAngle) / 2

        if normalisedAngle > math.pi * 2:
            normalisedAngle -= math.pi * 2
        elif normalisedAngle < 0:
            normalisedAngle += math.pi * 2

        return normalisedAngle


class RingLayout(Layout):
    """Set of chart areas for ring charts"""

    def __init__(self, slices):
        self.slices = slices

        self.title = Area()
        self.chart = Area()

        self.ticks = []
        self.radius = 0

        self._areas = (
            (self.title, (1, 126 / 255.0, 0)),  # orange
            (self.chart, (75 / 255.0, 75 / 255.0, 1.0)),  # blue
            )

        self._lines = []

    def update(self, cx, options, width, height, xticks, yticks):
        self.title.x = options.padding.left
        self.title.y = options.padding.top
        self.title.w = width - (options.padding.left + options.padding.right)
        self.title.h = get_text_extents(cx,
                                        options.title,
                                        options.titleFont,
                                        options.titleFontSize,
                                        options.encoding)[1]

        self.chart.x = self.title.x
        self.chart.y = self.title.y + self.title.h
        self.chart.w = self.title.w
        self.chart.h = height - self.title.h - (options.padding.top
                                                + options.padding.bottom)

        self.radius = min(self.chart.w / 2.0, self.chart.h / 2.0)

    def _get_min_radius(self, angle, centerx, centery, width, height):
        min_radius = None

        # precompute some common values
        tan = math.tan(angle)
        half_width = width / 2.0
        half_height = height / 2.0
        offset_x = half_width * tan
        offset_y = half_height / tan

        def intersect_horizontal_line(y):
            return centerx + (centery - y) / tan

        def intersect_vertical_line(x):
            return centery - tan * (x - centerx)

        # computes the intersection between the rect that has
        # that angle with the X axis and the bounding chart box
        if 0.25 * math.pi <= angle < 0.75 * math.pi:
            # intersects with the top rect
            y = self.chart.y
            x = intersect_horizontal_line(y)
            self._lines.append((x, y))

            x1 = x - half_width - offset_y
            self.ticks.append((x1, self.chart.y, width, height))

            min_radius = abs((y + height) - centery)
        elif 0.75 * math.pi <= angle < 1.25 * math.pi:
            # intersects with the left rect
            x = self.chart.x
            y = intersect_vertical_line(x)
            self._lines.append((x, y))

            y1 = y - half_height - offset_x
            self.ticks.append((x, y1, width, height))

            min_radius = abs(centerx - (x + width))
        elif 1.25 * math.pi <= angle < 1.75 * math.pi:
            # intersects with the bottom rect
            y = self.chart.y + self.chart.h
            x = intersect_horizontal_line(y)
            self._lines.append((x, y))

            x1 = x - half_width + offset_y
            self.ticks.append((x1, y - height, width, height))

            min_radius = abs((y - height) - centery)
        else:
            # intersects with the right rect
            x = self.chart.x + self.chart.w
            y = intersect_vertical_line(x)
            self._lines.append((x, y))

            y1 = y - half_height + offset_x
            self.ticks.append((x - width, y1, width, height))

            min_radius = abs((x - width) - centerx)

        return min_radius

    def _get_tick_position(self, radius, angle, tick, centerx, centery):
        text_width, text_height = tick[2:4]
        half_width = text_width / 2.0
        half_height = text_height / 2.0

        if 0 <= angle < 0.5 * math.pi:
            # first quadrant
            k1 = j1 = k2 = 1
            j2 = -1
        elif 0.5 * math.pi <= angle < math.pi:
            # second quadrant
            k1 = k2 = -1
            j1 = j2 = 1
        elif math.pi <= angle < 1.5 * math.pi:
            # third quadrant
            k1 = j1 = k2 = -1
            j2 = 1
        elif 1.5 * math.pi <= angle < 2 * math.pi:
            # fourth quadrant
            k1 = k2 = 1
            j1 = j2 = -1

        cx = radius * math.cos(angle) + k1 * half_width
        cy = radius * math.sin(angle) + j1 * half_height

        radius2 = math.sqrt(cx * cx + cy * cy)

        tan = math.tan(angle)
        x = math.sqrt((radius2 * radius2) / (1 + tan * tan))
        y = tan * x

        x = centerx + k2 * x
        y = centery + j2 * y

        return x - half_width, y - half_height, text_width, text_height
