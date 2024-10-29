def update_members(members):
    """This optional function is called by Qt.py to modify the modules exposed.

    Arguments:
        members (dict): The members considered by Qt.py
    """
    members["QtCore"].extend(['QState',
                              'QStateMachine',
                              'QHistoryState'])
    members['QtGui'].append('QGuiApplication')
    members['QtQuick'] = ['QQuickView']
