# @see http://stackoverflow.com/a/11048669/2866660
def scrolldown
  page.execute_script 'window.scrollBy(0,10000)'
end

def close_unit_conversion_popover
  # TODO: Make unit conversion popover more user-friendly?
  find('body > .logo').click
end
