#include <QtQml>
#include <QQmlExtensionPlugin>
#include <QQmlEngine>
#include <QTranslator>
#include <QGuiApplication>
#include <QLocale>

// using custom translator so it gets properly removed from qApp when engine is deleted
class AppTranslator: public QTranslator
{
    Q_OBJECT
public:
    AppTranslator(QObject *parent)
        : QTranslator(parent)
    {
        qApp->installTranslator(this);
    }

    virtual ~AppTranslator()
    {
        qApp->removeTranslator(this);
    }
};

class SailfishFileManagerPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "Sailfish.FileManager")

public:
    void initializeEngine(QQmlEngine *engine, const char *uri)
    {
        Q_UNUSED(uri)
        Q_ASSERT(QLatin1String(uri) == QLatin1String("Sailfish.FileManager"));

        AppTranslator *engineeringEnglish = new AppTranslator(engine);
        AppTranslator *translator = new AppTranslator(engine);
        engineeringEnglish->load("sailfish_components_filemanager_eng_en", "/usr/share/translations");
        translator->load(QLocale(), "sailfish_components_filemanager", "-", "/usr/share/translations");
    }
    virtual void registerTypes(const char *uri)
    {
        Q_UNUSED(uri)
        Q_ASSERT(QLatin1String(uri) == QLatin1String("Sailfish.FileManager"));
    }
};

#include "plugin.moc"
