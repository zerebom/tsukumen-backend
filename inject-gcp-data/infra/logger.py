from logging import getLogger, StreamHandler, FileHandler, Formatter

def get_logger(name, log_level='DEBUG',
               output_file=None,
               handler_level='INFO',
               output_level='DEBUG',
               format_str='%(asctime)s %(name)-4s %(levelname)-4s %(message)s'):
    """
    :param str name:
    :param str log_level:
    :param str | None output_file:
    :return: logger
    """
    logger = getLogger(name)

    formatter = Formatter(format_str)

    handler = StreamHandler()
    logger.setLevel(log_level)
    handler.setLevel(handler_level)
    handler.setFormatter(formatter)

    logger.handlers = []
    logger.addHandler(handler)

    if output_file:
        file_handler = FileHandler(output_file)
        file_handler.setFormatter(formatter)
        file_handler.setLevel(output_level)
        logger.addHandler(file_handler)

    return logger
